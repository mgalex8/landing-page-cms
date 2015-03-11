<h2><?php echo $result['title']; ?></h2>
<div class="span12" style="padding:40px">  
    <form action="<?php echo $result['action_url']; ?>" method="post">
        <table>
            <tr>
                <td class="span2"></td>
                <td><div class="error errors">                        
                        <?php
                            foreach ($result['errors'] as $err)
                            {
                                echo '<div>' . $err . '</div>';
                            }    
                        ?>
                    </div></td>
            </tr>
            <tr>
                <td class="span2"><?php echo __('Username'); ?>:</td>
                <td><input type="text" name="username" value="<?php echo $result['user']['username']; ?>" /></td>
            </tr>
            <tr>
                <td class="span2"><?php echo __('Password'); ?>:</td>
                <td><input type="password" name="password" value="" /></td>
            </tr>
            <tr>
                <td class="span2"><?php echo __('Confirm password'); ?>:</td>
                <td><input type="password" name="password2" value="" /></td>
            </tr>
            <tr>
                <td class="span2"><?php echo __('Email'); ?>:</td>
                <td><input type="text" name="email" value="<?php echo $result['user']['email']; ?>" /></td>
            </tr>
            <tr>
                <td class="span2"><?php echo __('Group'); ?>:</td>
                <td>
                    <select name="role_id">
                        <?php foreach ($result['groups'] as $group): ?>
                        <option value="<?php echo $role['id']; ?>" <?php if($result['user']['group_id']==$group['id']) echo "selected"; ?>><?php echo $group['title']; ?></option>
                        <?php endforeach; ?>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="span2"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo $result['title']; ?>" /></td>
            </tr>
        </table>        
    </form>
<div> 
    <pre><?php print_r($_SESSION); ?></pre>