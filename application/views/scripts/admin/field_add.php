<h2><?php echo $result['title']; ?></h2>
<div class="span12" style="padding:40px">    
    <form action="<?php echo $result['action_url']; ?>" method="post">        
        <table>
            <tr>
                <td class="span1"></td>
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
                <td class="span1"><?php echo __('ID'); ?>*:</td>
                <td><input type="text" name="name" value="<?php echo $result['field']['name']; ?>" /></td>
            </tr>
            <tr>
                <td class="span1"><?php echo __('Name'); ?>*:</td>
                <td><input type="text" name="title" value="<?php echo $result['field']['title']; ?>" /></td>
            </tr>           
            <tr>
                <td class="span1"><?php echo __('i18n'); ?>*:</td>
                <td><input type="text" name="i18n" value="<?php echo $result['field']['i18n']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span1" colspan="2">&nbsp</td>
            </tr>
            <tr>
                <td class="span1"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo $result['title']; ?>" /></td>
            </tr>
        </table>          
    </form>
<div>