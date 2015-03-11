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
                <td class="span2"><?php echo __('ID'); ?>*:</td>
                <td><input type="text" name="name" value="<?php echo $result['menu']['name']; ?>" /></td>
            </tr>           
            <tr>
                <td class="span2"><?php echo __('Title'); ?>*:</td>
                <td><input type="text" name="title" value="<?php echo $result['menu']['title']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2" colspan="2">&nbsp</td>
            </tr>
            <tr>
                <td class="span2"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo $result['title']; ?>" /></td>
            </tr>
        </table>          
    </form>
<div>